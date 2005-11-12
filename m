From: "Brian Wong" <bwong@pillardata.com>
Subject: [patch] hwtable.c entries
Date: Fri, 11 Nov 2005 16:34:49 -0800
Message-ID: <35D744B011AD9A4A86B5962E85181C78027AB6AE@caex02.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C5E720.E38E0D20"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5E720.E38E0D20
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

Can you apply this hwtable entry update?  It's below and attached.
Thanks!

Cheers,

brian

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -44,6 +44,9 @@ setup_default_hwtable (vector hw)
                   NULL, "0", "0", "tur", FAILBACK_UNDEF);
        r +=3D store_hwe_ext(hw, "SGI", "TP9500", FAILOVER,
DEFAULT_GETUID,
                   NULL, "0", "0", "tur", FAILBACK_UNDEF);
+       r +=3D store_hwe_ext(hw, "Pillar", "Axiom 500", GROUP_BY_PRIO,
+                   DEFAULT_GETUID, "/sbin/mpath_prio_alua %d", "0",
"0",
+                   "tur", FAILBACK_UNDEF);

        return r;
 }

------_=_NextPart_001_01C5E720.E38E0D20
Content-Type: application/octet-stream;
	name="mp_hwtable.diff"
Content-Transfer-Encoding: base64
Content-Description: mp_hwtable.diff
Content-Disposition: attachment;
	filename="mp_hwtable.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9od3RhYmxlLmMgYi9saWJtdWx0aXBhdGgvaHd0YWJs
ZS5jCi0tLSBhL2xpYm11bHRpcGF0aC9od3RhYmxlLmMKKysrIGIvbGlibXVsdGlwYXRoL2h3dGFi
bGUuYwpAQCAtNDQsNiArNDQsOSBAQCBzZXR1cF9kZWZhdWx0X2h3dGFibGUgKHZlY3RvciBodykK
IAkJICAgTlVMTCwgIjAiLCAiMCIsICJ0dXIiLCBGQUlMQkFDS19VTkRFRik7CiAJciArPSBzdG9y
ZV9od2VfZXh0KGh3LCAiU0dJIiwgIlRQOTUwMCIsIEZBSUxPVkVSLCBERUZBVUxUX0dFVFVJRCwK
IAkJICAgTlVMTCwgIjAiLCAiMCIsICJ0dXIiLCBGQUlMQkFDS19VTkRFRik7CisJciArPSBzdG9y
ZV9od2VfZXh0KGh3LCAiUGlsbGFyIiwgIkF4aW9tIDUwMCIsIEdST1VQX0JZX1BSSU8sIAorICAg
ICAgICAgICAgICAgICAgIERFRkFVTFRfR0VUVUlELCAiL3NiaW4vbXBhdGhfcHJpb19hbHVhICVk
IiwgIjAiLCAiMCIsIAorICAgICAgICAgICAgICAgICAgICJ0dXIiLCBGQUlMQkFDS19VTkRFRik7
CiAKIAlyZXR1cm4gcjsKIH0K

------_=_NextPart_001_01C5E720.E38E0D20
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C5E720.E38E0D20--
