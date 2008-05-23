From: "Laurent GEHLEN" <list.4.gehlen@gmail.com>
Subject: domap (0) failure for create/reload map
Date: Fri, 23 May 2008 11:58:22 +0200
Message-ID: <cbca94860805230258l48eaf9a9u4d4b1ee91ed79294@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1506504925=="
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

--===============1506504925==
Content-Type: multipart/alternative;
	boundary="----=_Part_9961_17390384.1211536702587"

------=_Part_9961_17390384.1211536702587
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Is there anybody who can help me to find where is my problem.
I'm trying to generate a mapper device with the tools multipath. But visibly
it blocs before it finish, because I don't have any new mapper device.
When i chose the verbose level 3 i can see those interesting things:

> # multipath -v3
> [...]
> sda: not found in pathvec
> [...]
> sdb: not found in pathvec
> [...]
> sdc: not found in pathvec
> [...]
> sdd: not found in pathvec
> [...]
> test: set ACT_CREATE (map does not exist)
> test: domap (0) failure for create/reload map
> [...]
> libdevmapper: libdm-common.c(239): Setting SELinux context for
> /dev/mapper/test to system_u:object_r:fixed_disk_device_t.
> [...]
>

I think the most interesting thing is the "domap (0) failure for
create/reload map".
I've read a bit about the code mutlipath
(cm/linux/storage/multipath-tools/libmultipath/configure.c+domap+(0)+failure+for+create/reload+map&hl=fr&ct=clnk&cd=4&gl=be&client=firefox-a)
And conclude (but not sure) that's the dm_addmap failed.

you can find the output of multipath -v3 here:
 --> http://rafb.net/p/J45SFA12.html

My multipath.conf here:
 --> http://rafb.net/p/G66QZ826.html

Thank you in advance for any idea!

Laurent

------=_Part_9961_17390384.1211536702587
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br><br>Is there anybody who can help me to find where is my problem.<br>I&#39;m trying to generate a mapper device with the tools multipath. But visibly it blocs before it finish, because I don&#39;t have any new mapper device.<br>

When i chose the verbose level 3 i can see those interesting things:<br><blockquote style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;" class="gmail_quote"># multipath -v3<br>
[...]<br>
sda: not found in pathvec<br>[...]<br>sdb: not found in pathvec<br>[...]<br>sdc: not found in pathvec<br>[...]<br>sdd: not found in pathvec<br>[...]<br>test: set ACT_CREATE (map does not exist)<br>test: domap (0) failure for create/reload map<br>

[...]<br>libdevmapper: libdm-common.c(239): Setting SELinux context for /dev/mapper/test to system_u:object_r:fixed_disk_device_t.<br>[...]<br></blockquote><br>I think the most interesting thing is the &quot;domap (0) failure for create/reload map&quot;.<br>

I&#39;ve read a bit about the code mutlipath (cm/linux/storage/multipath-tools/libmultipath/configure.c+domap+(0)+failure+for+create/reload+map&amp;hl=fr&amp;ct=clnk&amp;cd=4&amp;gl=be&amp;client=firefox-a)<br>And conclude (but not sure) that&#39;s the dm_addmap failed.<br>

<br>you can find the output of multipath -v3 here:<br>&nbsp;--&gt; <a href="http://rafb.net/p/J45SFA12.html" target="_blank">http://rafb.net/p/J45SFA12.html</a><br><br>My multipath.conf here:<br>&nbsp;--&gt; <a href="http://rafb.net/p/G66QZ826.html" target="_blank">http://rafb.net/p/G66QZ826.html</a><br>

<br>Thank you in advance for any idea!<br><br>Laurent<br><br>

------=_Part_9961_17390384.1211536702587--


--===============1506504925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1506504925==--
