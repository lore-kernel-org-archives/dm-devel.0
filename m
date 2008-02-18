From: "Derek Sherlock" <derek@sherlockmail.com>
Subject: Permissions of node files created by device-mapper
Date: Sun, 17 Feb 2008 17:10:00 -0700
Message-ID: <13033e750802171610g8e7c0a9sa7225dfa1f7e470e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1687367697=="
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

--===============1687367697==
Content-Type: multipart/alternative;
	boundary="----=_Part_2373_30503030.1203293400138"

------=_Part_2373_30503030.1203293400138
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Hope this is the right forum for this question.  If not, please redirect
me.  I've tried googling for this information without success.

When device mapper creates a node to represent a LVM logical volume (e.g.
/dev/mapper/vgrp_name-lvol_name), how does it decide the owner/group for the
node file.   Seems to be root/root by default, but I'm wondering if there's
a way to override it?  Is there some method (e.g. configuration file, kernel
parameter, etc.) that I should know about?

Thanks,
Derek.

------=_Part_2373_30503030.1203293400138
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>Hope this is the right forum for this question.&nbsp; If not, please redirect me.&nbsp; I&#39;ve tried googling for this information without success.<br><br>When device mapper creates a node to represent a LVM logical volume (e.g. /dev/mapper/vgrp_name-lvol_name), how does it decide the owner/group for the node file. &nbsp; Seems to be root/root by default, but I&#39;m wondering if there&#39;s&nbsp; a way to override it?&nbsp; Is there some method (e.g. configuration file, kernel parameter, etc.) that I should know about?<br>
<br>Thanks,<br>Derek.<br><br>

------=_Part_2373_30503030.1203293400138--


--===============1687367697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1687367697==--
