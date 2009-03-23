From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: Re: configure MD3000 episode 2
Date: Mon, 23 Mar 2009 17:05:37 -0400
Message-ID: <d1392840903231405p7b99846g65882690df77e96b@mail.gmail.com>
References: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
	<20090323143127.GA12731@mars.virtualiron.com>
	<d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
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

I'm now looking at the udev monitor and also set the loglevel to debug
and I can see that udev is processing the multipath events, hence
creating the /dev/mapper entries (but not the partition entries). But
there is never anything called that would create the /dev/dm-* devices
and the 95-kpartx rule is also never called it seems.
I have now rigged it to run a script on boot that calls mkdnod and
kpartx, but of course I'd still like udev support. I have not been
able to get any answer from ubuntu guys, so is it a fact that
multipath is basically not supported under ubuntu ? What would be the
next best distribution thats free of annual license fees ?

Thank you very much again,
Thomas


On Mon, Mar 23, 2009 at 11:44 AM, Thomas Witzel <witzel.thomas@gmail.com> wrote:
> Thanks, I added that. But it didn't change anything. I'm not sure what
> you want me to do with iscsi. I don't think I have an iscsi device. I
> have heard about the MD3000i before, but thats not what I have. I
> think I have a MD3000 (without i) connected via Symbios Logic SAS1068
> PCI-X Fusion-MPT SAS  controller.
>
> Thomas
>
> On Mon, Mar 23, 2009 at 10:31 AM, Konrad Rzeszutek
> <konrad@virtualiron.com> wrote:
>> On Fri, Mar 20, 2009 at 08:54:27PM -0400, Thomas Witzel wrote:
>>> I have a Dell NX1950 with a MD3000 running ubuntu server 8.04 . With
>>> the help of this list I managed to configure the RAID etc. However
>>> there is one remaining problem. udev doesn't seem to recognize this
>>> setup. After every reboot I have to manually create the /dev/dm-*
>>> devices with mknod and run kpartx to make the partitions show up. Can
>>> someone please hint to me where I get the appropriate udev scripts ?
>>
>> You can drop this in your udev/rules.d directory:
>>
>>> cat /etc/udev/rules.d/95-mpdc.rules
>> RUN+="socket:/org/kernel/dm/multipath_event"
>>
>>
>> Obviously you need to have your multipathd to start _before_ your
>> iSCSI daemon.
>>
>>> Ubuntu does have dmapper and multipath related scripts in the udev
>>> directory, but they don't seem to be working for me.
>>>
>>> Thank you so much,
>>> Thomas Witzel
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
