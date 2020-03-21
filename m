From: wangjufeng <wangjufeng@huawei.com>
Subject: multipathd: fix check_path could not resume path state
Date: Sat, 21 Mar 2020 15:53:42 +0000
Message-ID: <723608783F175343AAB90DD84928BC3405B3531C@dggeml530-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_723608783F175343AAB90DD84928BC3405B3531Cdggeml530mbschi_"
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_002_723608783F175343AAB90DD84928BC3405B3531Cdggeml530mbschi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From fb655da18aefccaa09c70036b08c88a03609ec45 Mon Sep 17 00:00:00 2001
From: wangjufeng <wangjufeng@huawei.com>
Date: Sat, 21 Mar 2020 22:23:10 +0800
Subject: [PATCH] multipathd: fix check_path could not resume path state

For some unknown reason, after network recovery from disconnection,
the paths in a multipath are still in fail state. Use gdb attached
multipathd, the paths seem to be changed by orphan_path function,
pp->initialized is INIT_OK while pp->mpp is NULL, pp->dmstate is
PSTATE_UNDEF, pp->fd is -1. And the multipath could not be found in
gvecs->mpvec while it could be found by dmsetup table command.

It will lead to that the path state could not be activated by
check_path even if the iscsi device is already available.

This patch intend to add the multipath map again to avoid IO failure
or IO blocked when the above phenomenon occur.

Signed-off-by: wangjufeng <wangjufeng@huawei.com>
Reviewed-by: linfeilong <linfeilong@huawei.com>
---
 multipathd/main.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++=
--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8baf9ab..4ca622c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1962,10 +1962,59 @@ check_path (struct vectors * vecs, struct path * pp=
, unsigned int ticks)
 =09struct config *conf;
 =09int marginal_pathgroups, marginal_changed =3D 0;
 =09int ret;
+=09char *param;
+        int major;
+        int minor;
+        int invalid =3D 0;
+        char dev_path[PATH_SIZE];
+        char *alias =3D NULL;
+=09struct multipath *mpp;
=20
 =09if ((pp->initialized =3D=3D INIT_OK ||
-=09     pp->initialized =3D=3D INIT_REQUESTED_UDEV) && !pp->mpp)
-=09=09return 0;
+=09     pp->initialized =3D=3D INIT_REQUESTED_UDEV) && !pp->mpp) {
+=09=09if (pp->initialized =3D=3D INIT_OK && !pp->mpp &&
+=09=09    pp->dmstate =3D=3D PSTATE_UNDEF && pp->fd =3D=3D -1) {
+=09=09=09mpp =3D find_mp_by_wwid(vecs->mpvec, pp->wwid);
+=09=09=09if (mpp !=3D NULL) {
+=09=09=09=09return 0;
+=09=09=09}
+=09=09=09/*
+=09=09=09 * If a multipath is not in gvecs->mpvec, while it could be found=
 in
+=09=09=09 * device-mapper devices. It should be mapped again, or multipath=
d
+=09=09=09 * can not add it again because of that check_path early return.
+=09=09=09 */
+=09=09=09param =3D convert_dev(pp->wwid, 0);
+=09=09=09conf =3D get_multipath_config();
+=09=09=09pthread_cleanup_push(put_multipath_config, conf);
+=09=09=09if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL) =
> 0) {
+=09=09=09=09invalid =3D 1;
+=09=09=09}
+=09=09=09pthread_cleanup_pop(1);
+=09=09=09if (invalid) {
+=09=09=09=09condlog(2, "%s: map blacklisted", param);
+=09=09=09=09return 0;
+=09=09=09}
+
+=09=09=09if (dm_get_major_minor(param, &major, &minor) < 0) {
+=09=09=09=09return 0;
+=09=09=09} else {
+=09=09=09=09sprintf(dev_path, "dm-%d", minor);
+=09=09=09=09alias =3D dm_mapname(major, minor);
+=09=09=09=09if (!alias) {
+=09=09=09=09=09condlog(2, "fail to get alias of %s %d:%d", param, major, m=
inor);
+=09=09=09=09=09return 0;
+=09=09=09=09}
+=09=09=09=09if (ev_add_map(dev_path, alias, vecs)) {
+=09=09=09=09=09condlog(2, "fail to add map for mpp %s", alias);
+=09=09=09=09=09return 0;
+=09=09=09=09} else {
+=09=09=09=09=09condlog(2, "success to add map for mpp %s", alias);
+=09=09=09=09}
+=09=09=09}
+=09=09} else {
+=09=09=09return 0;
+=09=09}
+=09}
=20
 =09if (pp->tick)
 =09=09pp->tick -=3D (pp->tick > ticks) ? ticks : pp->tick;
--=20
1.8.3.1


--_002_723608783F175343AAB90DD84928BC3405B3531Cdggeml530mbschi_
Content-Type: application/octet-stream;
	name="multipathd-fix-check_path-could-not-resume-path-stat.patch"
Content-Description: multipathd-fix-check_path-could-not-resume-path-stat.patch
Content-Disposition: attachment;
	filename="multipathd-fix-check_path-could-not-resume-path-stat.patch";
	size=3112; creation-date="Sat, 21 Mar 2020 15:43:24 GMT";
	modification-date="Sat, 21 Mar 2020 15:43:24 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmYjY1NWRhMThhZWZjY2FhMDljNzAwMzZiMDhjODhhMDM2MDllYzQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiB3YW5nanVmZW5nIDx3YW5nanVmZW5nQGh1YXdlaS5jb20+CkRh
dGU6IFNhdCwgMjEgTWFyIDIwMjAgMjI6MjM6MTAgKzA4MDAKU3ViamVjdDogW1BBVENIXSBtdWx0
aXBhdGhkOiBmaXggY2hlY2tfcGF0aCBjb3VsZCBub3QgcmVzdW1lIHBhdGggc3RhdGUKCkZvciBz
b21lIHVua25vd24gcmVhc29uLCBhZnRlciBuZXR3b3JrIHJlY292ZXJ5IGZyb20gZGlzY29ubmVj
dGlvbiwKdGhlIHBhdGhzIGluIGEgbXVsdGlwYXRoIGFyZSBzdGlsbCBpbiBmYWlsIHN0YXRlLiBV
c2UgZ2RiIGF0dGFjaGVkCm11bHRpcGF0aGQsIHRoZSBwYXRocyBzZWVtIHRvIGJlIGNoYW5nZWQg
Ynkgb3JwaGFuX3BhdGggZnVuY3Rpb24sCnBwLT5pbml0aWFsaXplZCBpcyBJTklUX09LIHdoaWxl
IHBwLT5tcHAgaXMgTlVMTCwgcHAtPmRtc3RhdGUgaXMKUFNUQVRFX1VOREVGLCBwcC0+ZmQgaXMg
LTEuIEFuZCB0aGUgbXVsdGlwYXRoIGNvdWxkIG5vdCBiZSBmb3VuZCBpbgpndmVjcy0+bXB2ZWMg
d2hpbGUgaXQgY291bGQgYmUgZm91bmQgYnkgZG1zZXR1cCB0YWJsZSBjb21tYW5kLgoKSXQgd2ls
bCBsZWFkIHRvIHRoYXQgdGhlIHBhdGggc3RhdGUgY291bGQgbm90IGJlIGFjdGl2YXRlZCBieQpj
aGVja19wYXRoIGV2ZW4gaWYgdGhlIGlzY3NpIGRldmljZSBpcyBhbHJlYWR5IGF2YWlsYWJsZS4K
ClRoaXMgcGF0Y2ggaW50ZW5kIHRvIGFkZCB0aGUgbXVsdGlwYXRoIG1hcCBhZ2FpbiB0byBhdm9p
ZCBJTyBmYWlsdXJlCm9yIElPIGJsb2NrZWQgd2hlbiB0aGUgYWJvdmUgcGhlbm9tZW5vbiBvY2N1
ci4KClNpZ25lZC1vZmYtYnk6IHdhbmdqdWZlbmcgPHdhbmdqdWZlbmdAaHVhd2VpLmNvbT4KUmV2
aWV3ZWQtYnk6IGxpbmZlaWxvbmcgPGxpbmZlaWxvbmdAaHVhd2VpLmNvbT4KLS0tCiBtdWx0aXBh
dGhkL21haW4uYyB8IDUzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5j
CmluZGV4IDhiYWY5YWIuLjRjYTYyMmMgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQvbWFpbi5jCisr
KyBiL211bHRpcGF0aGQvbWFpbi5jCkBAIC0xOTYyLDEwICsxOTYyLDU5IEBAIGNoZWNrX3BhdGgg
KHN0cnVjdCB2ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGggKiBwcCwgdW5zaWduZWQgaW50IHRp
Y2tzKQogCXN0cnVjdCBjb25maWcgKmNvbmY7CiAJaW50IG1hcmdpbmFsX3BhdGhncm91cHMsIG1h
cmdpbmFsX2NoYW5nZWQgPSAwOwogCWludCByZXQ7CisJY2hhciAqcGFyYW07CisgICAgICAgIGlu
dCBtYWpvcjsKKyAgICAgICAgaW50IG1pbm9yOworICAgICAgICBpbnQgaW52YWxpZCA9IDA7Cisg
ICAgICAgIGNoYXIgZGV2X3BhdGhbUEFUSF9TSVpFXTsKKyAgICAgICAgY2hhciAqYWxpYXMgPSBO
VUxMOworCXN0cnVjdCBtdWx0aXBhdGggKm1wcDsKIAogCWlmICgocHAtPmluaXRpYWxpemVkID09
IElOSVRfT0sgfHwKLQkgICAgIHBwLT5pbml0aWFsaXplZCA9PSBJTklUX1JFUVVFU1RFRF9VREVW
KSAmJiAhcHAtPm1wcCkKLQkJcmV0dXJuIDA7CisJICAgICBwcC0+aW5pdGlhbGl6ZWQgPT0gSU5J
VF9SRVFVRVNURURfVURFVikgJiYgIXBwLT5tcHApIHsKKwkJaWYgKHBwLT5pbml0aWFsaXplZCA9
PSBJTklUX09LICYmICFwcC0+bXBwICYmCisJCSAgICBwcC0+ZG1zdGF0ZSA9PSBQU1RBVEVfVU5E
RUYgJiYgcHAtPmZkID09IC0xKSB7CisJCQltcHAgPSBmaW5kX21wX2J5X3d3aWQodmVjcy0+bXB2
ZWMsIHBwLT53d2lkKTsKKwkJCWlmIChtcHAgIT0gTlVMTCkgeworCQkJCXJldHVybiAwOworCQkJ
fQorCQkJLyoKKwkJCSAqIElmIGEgbXVsdGlwYXRoIGlzIG5vdCBpbiBndmVjcy0+bXB2ZWMsIHdo
aWxlIGl0IGNvdWxkIGJlIGZvdW5kIGluCisJCQkgKiBkZXZpY2UtbWFwcGVyIGRldmljZXMuIEl0
IHNob3VsZCBiZSBtYXBwZWQgYWdhaW4sIG9yIG11bHRpcGF0aGQKKwkJCSAqIGNhbiBub3QgYWRk
IGl0IGFnYWluIGJlY2F1c2Ugb2YgdGhhdCBjaGVja19wYXRoIGVhcmx5IHJldHVybi4KKwkJCSAq
LworCQkJcGFyYW0gPSBjb252ZXJ0X2RldihwcC0+d3dpZCwgMCk7CisJCQljb25mID0gZ2V0X211
bHRpcGF0aF9jb25maWcoKTsKKwkJCXB0aHJlYWRfY2xlYW51cF9wdXNoKHB1dF9tdWx0aXBhdGhf
Y29uZmlnLCBjb25mKTsKKwkJCWlmIChmaWx0ZXJfd3dpZChjb25mLT5ibGlzdF93d2lkLCBjb25m
LT5lbGlzdF93d2lkLCBwYXJhbSwgTlVMTCkgPiAwKSB7CisJCQkJaW52YWxpZCA9IDE7CisJCQl9
CisJCQlwdGhyZWFkX2NsZWFudXBfcG9wKDEpOworCQkJaWYgKGludmFsaWQpIHsKKwkJCQljb25k
bG9nKDIsICIlczogbWFwIGJsYWNrbGlzdGVkIiwgcGFyYW0pOworCQkJCXJldHVybiAwOworCQkJ
fQorCisJCQlpZiAoZG1fZ2V0X21ham9yX21pbm9yKHBhcmFtLCAmbWFqb3IsICZtaW5vcikgPCAw
KSB7CisJCQkJcmV0dXJuIDA7CisJCQl9IGVsc2UgeworCQkJCXNwcmludGYoZGV2X3BhdGgsICJk
bS0lZCIsIG1pbm9yKTsKKwkJCQlhbGlhcyA9IGRtX21hcG5hbWUobWFqb3IsIG1pbm9yKTsKKwkJ
CQlpZiAoIWFsaWFzKSB7CisJCQkJCWNvbmRsb2coMiwgImZhaWwgdG8gZ2V0IGFsaWFzIG9mICVz
ICVkOiVkIiwgcGFyYW0sIG1ham9yLCBtaW5vcik7CisJCQkJCXJldHVybiAwOworCQkJCX0KKwkJ
CQlpZiAoZXZfYWRkX21hcChkZXZfcGF0aCwgYWxpYXMsIHZlY3MpKSB7CisJCQkJCWNvbmRsb2co
MiwgImZhaWwgdG8gYWRkIG1hcCBmb3IgbXBwICVzIiwgYWxpYXMpOworCQkJCQlyZXR1cm4gMDsK
KwkJCQl9IGVsc2UgeworCQkJCQljb25kbG9nKDIsICJzdWNjZXNzIHRvIGFkZCBtYXAgZm9yIG1w
cCAlcyIsIGFsaWFzKTsKKwkJCQl9CisJCQl9CisJCX0gZWxzZSB7CisJCQlyZXR1cm4gMDsKKwkJ
fQorCX0KIAogCWlmIChwcC0+dGljaykKIAkJcHAtPnRpY2sgLT0gKHBwLT50aWNrID4gdGlja3Mp
ID8gdGlja3MgOiBwcC0+dGljazsKLS0gCjEuOC4zLjEKCg==
--_002_723608783F175343AAB90DD84928BC3405B3531Cdggeml530mbschi_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_723608783F175343AAB90DD84928BC3405B3531Cdggeml530mbschi_--
