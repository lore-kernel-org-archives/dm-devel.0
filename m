From: Sheetal Singala <2396sheetal@gmail.com>
Subject: Fwd: [PATCH] md : dm: Fixed a brace coding style issue
Date: Thu, 16 May 2019 17:24:37 +0530
Message-ID: <CAGzrpOypt7xqgRr7tCUKA=sc1YqefARSM25Rw_-F6G9T3qZVig@mail.gmail.com>
References: <20190510174838.1968-1-2396sheetal@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7553541089540138098=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190510174838.1968-1-2396sheetal@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============7553541089540138098==
Content-Type: multipart/alternative; boundary="000000000000d82e170588ffee57"

--000000000000d82e170588ffee57
Content-Type: text/plain; charset="UTF-8"

Fixed a coding style issue.
---
 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 043f0761e4a0..2a8820bd581d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -781,7 +781,8 @@ static void close_table_device(struct table_device *td,
struct mapped_device *md
 }

 static struct table_device *find_table_device(struct list_head *l, dev_t
dev,
-                                             fmode_t mode) {
+                                             fmode_t mode)
+{
        struct table_device *td;

        list_for_each_entry(td, l, list)
-- 
2.17.1



-- 
Regards,
Sheetal Singala

--000000000000d82e170588ffee57
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_quote">Fixed a coding style issue.=
<br>
---<br>
=C2=A0drivers/md/dm.c | 3 ++-<br>
=C2=A01 file changed, 2 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/drivers/md/dm.c b/drivers/md/dm.c<br>
index 043f0761e4a0..2a8820bd581d 100644<br>
--- a/drivers/md/dm.c<br>
+++ b/drivers/md/dm.c<br>
@@ -781,7 +781,8 @@ static void close_table_device(struct table_device *td,=
 struct mapped_device *md<br>
=C2=A0}<br>
<br>
=C2=A0static struct table_device *find_table_device(struct list_head *l, de=
v_t dev,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0fmode_t mode) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0fmode_t mode)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct table_device *td;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(td, l, list)<br>
-- <br>
2.17.1<br>
<br>
</div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"gmail_signatur=
e" data-smartmail=3D"gmail_signature"><div dir=3D"ltr">Regards,<div>Sheetal=
 Singala</div></div></div></div>

--000000000000d82e170588ffee57--


--===============7553541089540138098==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7553541089540138098==--
