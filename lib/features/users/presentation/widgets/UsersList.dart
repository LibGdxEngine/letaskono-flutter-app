import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/ExpandingCircleProgress.dart';
import '../bloc/user_bloc.dart';
import 'GenderToggle.dart';
import 'UserCard.dart';

class UsersList extends StatefulWidget {
  final bool isFavourite;
  final UserBloc userBloc;

  const UsersList({
    super.key,
    required this.isFavourite,
    required this.userBloc,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final ScrollController _scrollController = ScrollController();
  final _prefs = GetIt.instance<SharedPreferences>();
  List<String>? visitedUsers;

  @override
  void initState() {
    super.initState();
    visitedUsers = _prefs.getStringList("visited_users") ?? [];
    // widget.userBloc.add(SetOnlineEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = widget.userBloc.state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        state is UsersLoaded &&
        state.hasMore) {
      widget.isFavourite
          ? widget.userBloc
              .add(FetchFavouritesEvent(page: state.currentPage + 1))
          : widget.userBloc.add(FetchUsersEvent(page: state.currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(child: ExpandingCircleProgress());
        } else if (state is UsersLoaded) {
          var genderSaved = _prefs.getString("filter_gender") ?? 'F';
          var maleIsSelected = genderSaved == "M" ? true : false;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(widget.isFavourite
                    ? FetchFavouritesEvent(
                        page: (state as UsersLoaded).currentPage,
                        isRefreshing: true,
                      )
                    : RefreshFetchUsersEvent(
                        isRefreshing: true,
                      ));
              },
              child: Column(
                children: [
                  Visibility(
                    visible: !widget.isFavourite,
                    child: GenderToggle(
                      isMaleSelected: maleIsSelected,
                      onChange: (isMaleSelected) => {
                        maleIsSelected = isMaleSelected,
                        _prefs.setString(
                            "filter_gender", isMaleSelected ? "M" : "F"),
                        context.read<UserBloc>().add(
                              ApplyFiltersEvent(
                                gender: isMaleSelected ? "M" : "F",
                              ),
                            ),
                      },
                    ),
                  ),
                  Expanded(
                    child: state.users.isNotEmpty
                        ? GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // Number of cards per row
                              crossAxisSpacing: 20,
                              // Horizontal spacing between cards
                              mainAxisSpacing: 20,
                              // Vertical spacing between cards
                              childAspectRatio:
                                  0.7, // Adjust aspect ratio for card size
                            ),
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              String userStyle = "";
                              if (user.gender == "M") {
                                if (user.le7ya == "ملتحي") {
                                  userStyle = "assets/images/photo3.png";
                                } else if (user.le7ya == "لحية خفيفة") {
                                  userStyle = "assets/images/photo1.png";
                                } else if (user.le7ya == "أملس") {
                                  userStyle = "assets/images/photo2.png";
                                }
                              } else if (user.gender == "F") {
                                if (user.hijab == "منتقبة سواد") {
                                  userStyle = "assets/images/wphoto1.png";
                                } else if (user.hijab == "منتقبة ألوان") {
                                  userStyle =
                                      "assets/images/photo_of_niqab_colored_woman.png";
                                } else if (user.hijab == "مختمرة") {
                                  userStyle = "assets/images/woman.png";
                                } else if (user.hijab == "طرح وفساتين") {
                                  userStyle = "assets/images/woman.png";
                                } else {
                                  userStyle = "assets/images/woman.png";
                                }
                              }
                              final visitedBefore =
                                  visitedUsers?.contains(user.code) ?? false;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!visitedBefore) {
                                      visitedUsers?.add(user.code);
                                      _prefs.setStringList(
                                          "visited_users", visitedUsers ?? []);
                                    }
                                    Navigator.pushNamed(
                                      context,
                                      '/userDetail',
                                      arguments: state.users[index]
                                          .code, // Pass the 'id' as an argument
                                    );
                                  });
                                },
                                child: UserCard(
                                  imageUrl: userStyle,
                                  userCode: user.code,
                                  styleOfPerson: user.gender == "M"
                                      ? user.le7ya
                                      : user.hijab,
                                  isOnline: user.isOnline,
                                  maritalStatus: user.maritalStatus,
                                  age: user.age,
                                  nationality: user.nationality,
                                  stateWhereLive: user.state,
                                  visitedBefore: visitedBefore,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: widget.isFavourite
                                ? const Text("ليس هناك محفوظات")
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 24,
                                          Icons.filter_alt_off_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const Text("ليس هناك مستخدمين"),
                                      ],
                                    ),
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is UsersError) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('هناك خطأ في استقبال البيانات !'),
              const Text('تأكد من إتمام تفعيل حسابك عن طريق'),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () =>
                      {Navigator.pushNamed(context, "/profileSetup")},
                  child: const Text('تعبئة البيانات'))
            ],
          ));
        } else {
          return Center(child: ExpandingCircleProgress());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // widget.userBloc.add(SetOfflineEvent());
    super.dispose();
  }
}
