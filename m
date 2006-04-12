From: Arsene Gschwind <arsene.gschwind@unibas.ch>
Subject: Re: multipath disk size
Date: Wed, 12 Apr 2006 14:19:21 +0200
Message-ID: <443CF049.40003@unibas.ch>
References: <4436271F.1090509@unibas.ch> <4436E844.2090301@free.fr>
	<443C098D.1090604@unibas.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443C098D.1090604@unibas.ch>
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

I've found something strange, 2 declaration of SERIAL_SIZE with=20
different sizes
libmultipath/structs.h:#define SERIAL_SIZE              17
path_priority/pp_balance_units/pp_balance_units.c:#define SERIAL_SIZE 255

In my case the first buffer size is to small because pp->serial has a=20
size of 17 chars and when you look at my output it has 40 chars.
By setting libmultipath/structs.h:#define SERIAL_SIZE    to 255 it works=20
for me and the returned volume size is correct.
I'm not sure if this is the right solution, it would be great if someone=20
could verify that issue.

Thanks a lot for your work
Ars=E8ne

URZ- AG wrote:

>
>
> Christophe Varoqui wrote:
>
>>>
>> Thanks for this report.
>>
>> I can't reproduce this here.
>>
>> I'm afraid I'll have to ask you to try and refine your report though.
>> Use a debugger to track [m]pp->size changes, or try adding debugging=20
>> output in the key code areas : add_map_with_path(), coalesce_paths(),=20
>> ...
>>
>> Regards,
>> cvaroqui
>>
> Hello Christophe,
>
> I'm not a C Guru but i think i have been able to track it down.
> It seems that when discovering the device for paths after the=20
> get_serial (discovery.c) function the size has changed.
> I've entered two debug entries in  scsi_ioctl_pathinfo() which prints=20
> out  pp->size, one before get_serial call and one after and the size=20
> has changed when the second print its value. So far I've seen, this=20
> function should not change anything to the size, but it seems to write=20
> to that pointer, could it be that this function writes out of a buffer=20
> size?
> I'm not comfortable with the debugger so I have not been able to debug=20
> that in deep.
> It would be great if  you could give me some more instructions on how=20
> to analyze/debug it .
>
> Regards,
> Ars=E8ne
>
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=20
***********************************************************
Gschwind Arsene		=09
Universitaet Rechenzentrum (URZ)
Klingelbergstrasse 70
CH-4056 Basel
SWITZERLAND

Languages : F/E/D
WWW:  <http://www.urz.unibas.ch>
Mail: <Arsene DOT Gschwind AT unibas DOT ch>
************************************************************
