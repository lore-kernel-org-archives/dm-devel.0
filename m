From: lbt <transter@gmail.com>
Subject: [PATCH] garbled output after rename map and rerun
	multipath
Date: Tue, 6 Jun 2006 14:36:05 -0700
Message-ID: <ac71172a0606061436o6ac13146ga04dd1dfe5c06711@mail.gmail.com>
Reply-To: transter@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0640294483=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0640294483==
Content-Type: multipart/alternative;
	boundary="----=_Part_4390_16496826.1149629765964"

------=_Part_4390_16496826.1149629765964
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

There was some garbled output after renaming a multipath device and
rerunning multipath.
This is just a minor fix to add some actions that were missing.

Thanks,
lan

--- multipath-git/libmultipath/print.c  2006-06-05 14:26:52.000000000 -0700
+++ multipath-tools-2006.6.5-changed/libmultipath/print.c       2006-06-06
13:48:54.000000000 -0700
@@ -211,12 +211,16 @@
 snprint_action (char * buff, size_t len, struct multipath * mpp)
 {
        switch (mpp->action) {
+       case ACT_REJECT:
+               return snprint_str(buff, len, ACT_REJECT_STR);
        case ACT_RELOAD:
                return snprint_str(buff, len, ACT_RELOAD_STR);
-       case ACT_CREATE:
-               return snprint_str(buff, len, ACT_CREATE_STR);
        case ACT_SWITCHPG:
                return snprint_str(buff, len, ACT_SWITCHPG_STR);
+       case ACT_RENAME:
+               return snprint_str(buff, len, ACT_RENAME_STR);
+       case ACT_CREATE:
+               return snprint_str(buff, len, ACT_CREATE_STR);
        default:
                return 0;
        }

------=_Part_4390_16496826.1149629765964
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>There was some garbled output&nbsp;after renaming a multipath device and rerunning multipath. </div>
<div>This is just a minor fix to add some actions that were missing. </div>
<div>&nbsp;</div>
<div>Thanks,</div>
<div>lan</div>
<div>&nbsp;</div>
<div>--- multipath-git/libmultipath/print.c&nbsp; 2006-06-05 14:26:52.000000000 -0700<br>+++ multipath-tools-2006.6.5-changed/libmultipath/print.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2006-06-06 13:48:54.000000000 -0700<br>@@ -211,12 +211,16 @@<br>&nbsp;snprint_action (char * buff, size_t len, struct multipath * mpp)
<br>&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; switch (mpp-&gt;action) {<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case ACT_REJECT:<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprint_str(buff, len, ACT_REJECT_STR);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case ACT_RELOAD:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprint_str(buff, len, ACT_RELOAD_STR);
<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case ACT_CREATE:<br>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprint_str(buff, len, ACT_CREATE_STR);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case ACT_SWITCHPG:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprint_str(buff, len, ACT_SWITCHPG_STR);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case ACT_RENAME:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprint_str(buff, len, ACT_RENAME_STR);<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case ACT_CREATE:<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return snprint_str(buff, len, ACT_CREATE_STR);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;</div>

------=_Part_4390_16496826.1149629765964--


--===============0640294483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0640294483==--
