From: "Paul Tader" <ptader@linuxscope.com>
Subject: Re: New disk under /dev/mapper control?? [RESOLVED]
Date: Tue, 10 Apr 2007 10:01:52 -0500 (CDT)
Message-ID: <43710.131.225.80.2.1176217312.squirrel@mail.linuxscope.com>
References: <44864.131.225.80.2.1176154166.squirrel@mail.linuxscope.com>
	<20070410052536.GA1464@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070410052536.GA1464@percy.comedia.it>
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

> On Mon, Apr 09, 2007 at 04:29:26PM -0500, Paul Tader wrote:
>>I've added a new, single IDE disk to a system.  I've run though fdisk,
> It does not look "new" to me...
>
>>mkfs and then attempted a mount command but mount failed with "already
>>mounted or /mnt/ busy".  I see that now device-mapper is "claiming" thi=
s
>>disk and newly created partitions and doesn't allow me to mount the
>>partitions by addressing the /dev/hdb1 device file. In other words,
>>/dev/mapper files are being automatically created only for this (new)
>>disk.  Is there a way to have device-mapper relinquish control of this
>>disk?
> it is not device mapper, but dmraid
> i believe your ide disk was 'touched' by a promise fakeraid controller.
> your init scripts probably call dmraid during boot and finding a promis=
e
> fakeraid metadata on the disk dmraid activates it.
>
>>I've tried removing and clearing the devices with dmsetup, all to no
>> avail.
> you could try removing the fakeraid metadata with dmraid -E.
> if the promise fakeraid adapter is installed in your PC you might have
> to disable fakeraid in the bios first.
>

Thanks Luca, the dmraid command corrected things.

[root@server ~]# dmraid -r
/dev/hdb: pdc, "pdc_bjajcgbifh", stripe, ok, 781422592 sectors, data@ 0
[root@server ~]# dmraid -rE
Do you really want to erase "pdc" ondisk metadata on /dev/hdb ? [y/n] :y

...then I ran:

[root@server ~]# dmsetup remove /dev/mapper/pdc_bjajcgbifh1
[root@server ~]# dmsetup remove /dev/mapper/pdc_bjajcgbifh

and rebooted.  This time the /dev/mapper devices were not recreated and I
was able to mount the partition using the standard device file, /dev/hdb1=
.

Thanks again,
Paul Tader

--
www.linuxscope.com

> L.
>
> --
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
