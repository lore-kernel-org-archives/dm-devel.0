From: devzero@web.de
Subject: Re: device-errors and multipath device access issue
Date: Wed, 14 Nov 2007 23:36:10 +0100
Message-ID: <2085496865@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
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
To: tore@linpro.no
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> for each alternative path to a lun.
>
>>I assume you mean "for each path to the alternate controller of the vol=
ume".

yes, indeed.

>> we also get those messages when the system is up and running because
>> some proprietary monitoring software is checking for device
>> availability in regular intervals and there seems no way to tell that
>> software to skip certain devices - so we get spammed with this
>> messages like this in /var/log/messages and are not able to see the
>> real errors anymore.
>>=20
>> is there a way to hide those "classic" scsi devices from userspace?=20
>> i`m not sure if "blacklist" in multipath.conf is what i need here (?)
>> or if i safely could delete those device-nodes - i`m not very deep
>> into multipathing for now.
>
>I don't think you can (without at the same time taking away
>dm-multipath's ability to fail over I/O to those paths...

ok - then i must live with this and hope that proprietary application can=
 be stopped touching these....

>You're not saying which kind of storage hardware this is. =20

sorry. it`s an EMC Clariion CX500

>Maybe it has a way of being configured in a fake active/active configura=
tion where
>I/O can be processed on both controllers at the same time.  I believe
>newer EMC CLARiiON and HP EVA can be set up in ALUA mode which does the
>trick. HDS AMS does something similar which work mostly the same way.

yes - but i don`t think the admin wants to touch such essential configura=
tion to get rid of error messages in the kernel-log....

>You might also be able to filter out those lines from the logs, too.  I
>think at least syslog-ng can be made to do that.

ok, but that`s not an elegant way to go....

>> in our case, kpartx doesn`t seem to be launched by udev but from
>> within boot.multipath, but it looks like a timing issue because it
>> sometimes happens and sometimes not.
>>=20
>> any help or some input (links?docs?) to enlighten me would be highly
>> appreciated
>
>I'd suggest simply not making partitions - make several smaller volumes
>on your storage array instead.  That'll make it easier to expand them
>individually if the need should arise, and you won't have to deal with
>kpartx at all.  There's always some kind of trouble with it, in my
>experience.  Same goes for udev...

meanwhile, i found a novell paper which recommends the same - no partitio=
ns and access access /dev/disk instead of /dev/mapper
will discuss moving to a non partitioned scenario.

thanks.

roland
_______________________________________________________________________
Jetzt neu! Sch=FCtzen Sie Ihren PC mit McAfee und WEB.DE. 3 Monate
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=3D022220
