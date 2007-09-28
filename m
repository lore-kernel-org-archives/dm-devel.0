From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: Re: fdisk on a multipath device fails kernel partition
	re-read
Date: Fri, 28 Sep 2007 16:32:55 -0400
Message-ID: <5fb0f77b0709281332n56832c2bocfec48077040887a@mail.gmail.com>
References: <448b15030709281328i104c04f0te6dd1ef333b825a3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0300252308=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <448b15030709281328i104c04f0te6dd1ef333b825a3@mail.gmail.com>
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

--===============0300252308==
Content-Type: multipart/alternative;
	boundary="----=_Part_2880_28881972.1191011575959"

------=_Part_2880_28881972.1191011575959
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I alwase use the entire disk .. no partitions, and I usually do mkfs on the
underlying /dev/sdX device before
I bother with multipath..
Then I just use the /dev/mapper entries for  actual mounts .. the
underlying FS is already there.
just my .02

mkfs.ext3 -F /dev/sdX

On 9/28/07, David Strand <dpstrand@gmail.com> wrote:
>
> When I perform an fdisk or sfdisk on a /dev/mapper/ multipath device I
> get a warning about it failing to re-read the partition information.
> With fdisk it warns that I'll need to reboot before using the device,
> with sfdisk it just complains about the ioctl that failed:
>
> Re-reading the partition table ...
> BLKRRPART: Invalid argument
>
> Is it possible I have something configured wrong? Or is this a problem
> with the way /dev/mapper nodes work? I get the same result when using
> /dev/dm-* nodes. With the raw device nodes such as /dev/sd* it works
> ok.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
:wq!
kevin.foote

------=_Part_2880_28881972.1191011575959
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I alwase use the entire disk .. no partitions, and I usually do mkfs on the underlying /dev/sdX device before <br>I bother with multipath..<br>Then I just use the /dev/mapper entries for&nbsp; actual mounts .. the&nbsp; underlying FS is already there.
<br>just my .02 <br><br> mkfs.ext3 -F /dev/sdX <br><br><div><span class="gmail_quote">On 9/28/07, <b class="gmail_sendername">David Strand</b> &lt;<a href="mailto:dpstrand@gmail.com">dpstrand@gmail.com</a>&gt; wrote:</span>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">When I perform an fdisk or sfdisk on a /dev/mapper/ multipath device I<br>get a warning about it failing to re-read the partition information.
<br>With fdisk it warns that I&#39;ll need to reboot before using the device,<br>with sfdisk it just complains about the ioctl that failed:<br><br>Re-reading the partition table ...<br>BLKRRPART: Invalid argument<br><br>Is it possible I have something configured wrong? Or is this a problem
<br>with the way /dev/mapper nodes work? I get the same result when using<br>/dev/dm-* nodes. With the raw device nodes such as /dev/sd* it works<br>ok.<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">
dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></div><br><br clear="all"><br>-- <br>:wq!<br>kevin.foote

------=_Part_2880_28881972.1191011575959--


--===============0300252308==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0300252308==--
