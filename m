From: "=?GB2312?B?0Lu42Q==?=" <xiegang112@gmail.com>
Subject: Re: How does multipath tool handle Lun remapping?
Date: Tue, 20 Jan 2009 11:17:53 +0800
Message-ID: <d364733c0901191917y76543be4o5b14f29c057d1bd5@mail.gmail.com>
References: <d364733c0901160042n65184828pcac1e7a6435b6c9c@mail.gmail.com>
	<20090116181327.GD1493@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090116181327.GD1493@mars.virtualiron.com>
Content-Disposition: inline
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

It make sense that multipath tool can notice that there is a
recreation of OS device. But it still depends on the external program,
such as scsi_id to get the identifier of the lun=A1=A3
I looked through the scsi_id source code, found that unit serial
number might be returned if the device supported the EVPD inquery
page80. This might be the wrong infomation for multipath tool, is that
true?

Thanks,

On Sat, Jan 17, 2009 at 2:13 AM, Konrad Rzeszutek
<konrad@virtualiron.com> wrote:
> On Fri, Jan 16, 2009 at 04:42:25PM +0800, =D0=BB=B8=D9 wrote:
>> Hi,
>>
>> multipath path tool use the external program, such as scsi_id in udev,
>> to get the id of the lun. But how does it handle the lun remapping?
>> For example, at first, thiere is a lun in array:lun1, it is mapped to
>> host with lun id 11. On the host, I use the multipath program to
>> generate a multipath device for this lun. Then I unmap lun1 and
>> another lun: lun2 which is mapped to the host with the same lun id 11.
>
> Do you reboot the system after those unmaps/maps?
>
>> In this situation, it seems that the multipath tool could not notice
>> that there is a change of lun even after recreate the multipath
>> device, is that true?
>
> It would - as long as hte block devices get re-created/deleted
> for the new/old LUNs.
>
>>
>> Thanks,
>>
>> --
>> Xie Gang
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Xie Gang
