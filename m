From: Nicholas Nevin <njnevin@gmail.com>
Subject: Re: /dev/mapper/<dm_name> symlink not being created
Date: Sat, 12 May 2012 10:59:14 -0400
Message-ID: <CACmkXc5cEhvdBgHzbNW13cFcoj83LjFea=qwZOq5UUq5vpwdAw@mail.gmail.com>
References: <CACmkXc5fQCF78UW1_tEruAiuWL_EgODLt87=ZD-d_f2zT-GPeA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8469499124818400949=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACmkXc5fQCF78UW1_tEruAiuWL_EgODLt87=ZD-d_f2zT-GPeA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============8469499124818400949==
Content-Type: multipart/alternative; boundary=047d7b15a97377a65404bfd81ada

--047d7b15a97377a65404bfd81ada
Content-Type: text/plain; charset=ISO-8859-1

Anyone have any thoughts on this?

Thanks, Nick.

On Mon, Apr 30, 2012 at 8:08 AM, Nicholas Nevin <njnevin@gmail.com> wrote:

> In nightly testing of our product the tests do a fair bit of
> creating/destroying of device mapper devices and we have been seeing
> infrequent cases where the device is created OK but the corresponding
> /dev/mapper/<dm_name> symlink does not exist.
>
> Here is an example of the dmsetup command used to create the devices.
>
> # dmsetup create tap0 --table '0 47247164 linear /dev/xen/blktap-2/tapdev0
> 1'
>
> I managed to reproduce this problem with udev logging enabled and 'udevadm
> monitor' running and from the logs the cause appears to be that the udev
> add action (from the device create) and the udev change action (from when
> the device is resumed after loading the table) are running
> concurrently. The processing of the rules for the change action creates the
> /dev/mapper/tap0 symlink but then the processing of the add action deletes
> the symlink because /dev/mapper/tap0 is not in the add action DEVLINKS.
>
> The question I have is should dmsetup be ensuring that the add action
> completes before the change action is handled or is this behaviour expected?
>
> That /dev/mapper/tap0 is not in the DEVLINKS for the add action is AFAICT
> because of a race between the creation of the sysfs entries for the device
> and the processing of the add action in udevd. This can be fixed by
> sprinkling in some WAIT_FOR conditions in the dm udev rules. Our system is
> based on Ubuntu 12.04.
>
> I have attached the udevadm monitor output and the relevant piece of
> syslog for a test case where the /dev/mapper/tap0 symlink wasn't present
> when dmsetup returned.
>
> I hope this is the right place to ask this. If not please point me in the
> right direction.
>
> Thanks, Nick.
>
>

--047d7b15a97377a65404bfd81ada
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anyone have any thoughts on this?<div><br></div><div>Thanks, Nick.</div><di=
v><br><div class=3D"gmail_quote">On Mon, Apr 30, 2012 at 8:08 AM, Nicholas =
Nevin <span dir=3D"ltr">&lt;<a href=3D"mailto:njnevin@gmail.com" target=3D"=
_blank">njnevin@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">In nightly testing of our product the tests =
do a fair bit of creating/destroying of device mapper devices and we have b=
een seeing infrequent cases=A0where the device is created OK but the corres=
ponding /dev/mapper/&lt;dm_name&gt; symlink does not exist.<div>



<br></div><div>Here is an example of the dmsetup command used to create the=
 devices.</div><div><br></div><div># dmsetup create tap0 --table &#39;0 472=
47164 linear /dev/xen/blktap-2/tapdev0 1&#39;</div><div><br></div><div>



I managed to reproduce this problem with udev logging enabled and &#39;udev=
adm monitor&#39; running and from the logs the cause appears to be that the=
 udev add action (from the device create) and the udev change action (from =
when the device is resumed after loading the table) are running concurrentl=
y.=A0The processing of the rules for the change action creates the /dev/map=
per/tap0 symlink but then the processing of the add action deletes the syml=
ink because /dev/mapper/tap0 is not in the add action DEVLINKS.</div>



<div><br></div><div>The question I have is should dmsetup=A0be ensuring tha=
t the add action completes before the change action is handled or is this b=
ehaviour expected?</div><div><br></div><div>That /dev/mapper/tap0 is not in=
 the DEVLINKS for the add action is AFAICT because of a race between the cr=
eation of the sysfs entries for the device and the processing of the add ac=
tion in udevd. This can be fixed by sprinkling in some WAIT_FOR conditions =
in the dm udev rules. Our system is based on Ubuntu 12.04.</div>



<div><br></div><div>I have attached the udevadm monitor output and the rele=
vant piece of syslog for a test case where the /dev/mapper/tap0 symlink was=
n&#39;t present when dmsetup returned.</div><div><br></div><div>I hope this=
 is the right place to ask this. If not please point me in the right direct=
ion.</div>



<div><br></div><div>Thanks, Nick.</div><div><br></div>
</blockquote></div><br></div>

--047d7b15a97377a65404bfd81ada--


--===============8469499124818400949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8469499124818400949==--
