From: URZ- AG <arsene.gschwind@unibas.ch>
Subject: Re: multipath disk size
Date: Tue, 11 Apr 2006 21:54:53 +0200
Message-ID: <443C098D.1090604@unibas.ch>
References: <4436271F.1090509@unibas.ch> <4436E844.2090301@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4436E844.2090301@free.fr>
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



Christophe Varoqui wrote:

>>
> Thanks for this report.
>
> I can't reproduce this here.
>
> I'm afraid I'll have to ask you to try and refine your report though.
> Use a debugger to track [m]pp->size changes, or try adding debugging=20
> output in the key code areas : add_map_with_path(), coalesce_paths(), .=
..
>
> Regards,
> cvaroqui
>
Hello Christophe,

I'm not a C Guru but i think i have been able to track it down.
It seems that when discovering the device for paths after the get_serial=20
(discovery.c) function the size has changed.
I've entered two debug entries in  scsi_ioctl_pathinfo() which prints=20
out  pp->size, one before get_serial call and one after and the size has=20
changed when the second print its value. So far I've seen, this function=20
should not change anything to the size, but it seems to write to that=20
pointer, could it be that this function writes out of a buffer size?
I'm not comfortable with the debugger so I have not been able to debug=20
that in deep.
It would be great if  you could give me some more instructions on how to=20
analyze/debug it .

Regards,
Ars=E8ne
