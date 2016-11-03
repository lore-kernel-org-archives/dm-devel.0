From: James Shoemaker <james@dhlake.com>
Subject: multipath bug and patch
Date: Thu, 3 Nov 2016 13:34:17 -0500
Message-ID: <CALRmJ1tJvjrVe9V9ZTeX+K-R9BMVf9wzbVVY5PV5jSXU3EG6Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5402438507825764055=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5402438507825764055==
Content-Type: multipart/alternative; boundary=94eb2c0d90582ad866054069ce07

--94eb2c0d90582ad866054069ce07
Content-Type: text/plain; charset=UTF-8

   If a device returns an empty string for inquiry data the current
multipath tool ignores it on reload.  I added the following patch and I can
hotplug these devices that don't return all the proper data.

diff --git a/libmultipath/util.c b/libmultipath/util.c
index ac0d1b2..045e660 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -17,6 +17,10 @@ strchop(char *str)

        for (i=strlen(str)-1; i >=0 && isspace(str[i]); --i) ;
        str[++i] = '\0';
+       if(strlen(str)==0)
+       {
+               strcpy(str,"none");
+       }
        return strlen(str);
 }

James Shoemaker

--94eb2c0d90582ad866054069ce07
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>=C2=A0=C2=A0 If a device returns an empty string for =
inquiry data the current multipath tool ignores it on reload.=C2=A0 I added=
 the following patch and I can hotplug these devices that don&#39;t return =
all the proper data.<br><br>diff --git a/libmultipath/util.c b/libmultipath=
/util.c<br>index ac0d1b2..045e660 100644<br>--- a/libmultipath/util.c<br>++=
+ b/libmultipath/util.c<br>@@ -17,6 +17,10 @@ strchop(char *str)<br>=C2=A0<=
br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i=3Dstrlen(str)-1; i &gt=
;=3D0 &amp;&amp; isspace(str[i]); --i) ;<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 str[++i] =3D &#39;\0&#39;;<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if(strlen(str)=3D=3D0)<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {<br=
>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 strcpy(str,&quot;none&quot;);<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return strlen(str=
);<br>=C2=A0}<br><br></div>James Shoemaker<br></div>

--94eb2c0d90582ad866054069ce07--


--===============5402438507825764055==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5402438507825764055==--
