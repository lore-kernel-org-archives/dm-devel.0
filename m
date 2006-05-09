From: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Subject: Tested APPLE Xserve RAID with multipath
Date: Tue, 9 May 2006 20:11:38 +0100 (BST)
Message-ID: <20060509191138.3401.qmail@web8514.mail.in.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I tested Apple's Xserve RAID with the multipath tools.

Here is the entry I had to make in the config file, if
one wants to add it to the dafault table:

{                                                    =20
                                                     =20

              .vendor        =3D "APPLE ",             =20
                                                     =20
     =20
              .product       =3D "Xserve RAID ",       =20
                                                     =20
     =20
              .getuid        =3D DEFAULT_GETUID,       =20
                                                     =20
     =20
              .getprio       =3D NULL,                 =20
                                                     =20
     =20
              .features      =3D DEFAULT_FEATURES,     =20
                                                     =20
     =20
              .hwhandler     =3D DEFAULT_HWHANDLER,    =20
                                                     =20
     =20
              .selector      =3D DEFAULT_SELECTOR,     =20
                                                     =20
     =20
              .pgpolicy      =3D MULTIBUS,             =20
                                                     =20
     =20
              .pgfailback    =3D FAILBACK_UNDEF,       =20
                                                     =20
     =20
              .rr_weight     =3D RR_WEIGHT_NONE,       =20
                                                     =20
     =20
              .no_path_retry =3D NO_PATH_RETRY_UNDEF,  =20
                                                     =20
     =20
              .minio         =3D DEFAULT_MINIO,        =20
                                                     =20
     =20
              .checker_name  =3D DEFAULT_CHECKER,      =20
                                                     =20
     =20
      },

-Shyam


	=09
__________________________________________________________=20
Yahoo! India Answers: Share what you know. Learn something new.=20
http://in.answers.yahoo.com
