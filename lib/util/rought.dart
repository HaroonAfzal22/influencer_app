/*
        final userData = await users
            .where('email', isEqualTo: auth.currentUser?.email)
            .get();

        final d = userData.docs.single;

        ub.uid = d['uid'];
    */

        // devtools.log('current user data ${ub.uid}');

        //   users.snapshots().map(
        // (query) => query.docs.map((item) => UserModal.fromMap(item)).single);

        /*
        final userdata = await users
            .where('email', isEqualTo: auth.currentUser?.email)
            .get();
        userModal = userdata.docs.map((e) => UserModal.fromMap(e)).single;
      */

        // devtools.log('modal response ${userModal.docId}');

        // devtools.log(
        //     'user data is printing  userModal.uid and name  ${ub.name} uid ::: ${ub.uid}');

        /*    leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),*/


            /*
               GetX<HomeController>(builder: (_) {
                        return Container(
                          height: 100,
                          child: ListView(
                            children: [
                              Text(_.currentUser!.name.toString()),
                              Text(_.currentUser!.time.toString()),
                              Text(_.currentUser!.status.toString()),
                              Text(_.currentUser!.userRole.toString()),
                            ],
                          ),
                        );
                      }),
            
            */