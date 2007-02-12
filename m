From: Srini <v.vvsrini@gmail.com>
Subject: Linux 2.6.19.1 device mapper error
Date: Mon, 12 Feb 2007 06:23:54 +0530
Message-ID: <25b3869e0702111653re7487ffq1ff1f2ebf263bc20@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On further debugging, we found that if we are using a kernel version
2.6.16, the device mapper was functioning correctly as expected. The
device mapper version in 2.6.16 is 4.5.0-ioctl and the device mapper
version in  2.6.19.1 kernel is 4.11.0-ioctl.

Is there a difference between the 4.5.0 version and 4.11.0 version
that could be causing the problem that we are facing? Is there a list
of changes that has gone into device-mapper between these two
versions?

Thanks in advance for your inputs,

Srini

On 2/8/07, Srini <v.vvsrini@gmail.com> wrote:
> Hi all,
>
> I am currently trying to create a snapshot through EVMS (v2.5.4) and I am getting an error from the device mapper module in the kernel version 2.6.19.1 (dmesg). The following is the error message:
>
> device-mapper: table: 253:2: snapshot-origin: unknown target type
> device-mapper: ioctl: error adding target to table
> device-mapper: table: 253:7: snapshot: requires exactly 4 arguments
> device-mapper: ioctl: error adding target to table
> device-mapper: table: 253:7: snapshot: requires exactly 4 arguments
> device-mapper: ioctl: error adding target to table
>
> The lsmod command on the same machine shows the dm-snapshat module to have been successfully inserted:
>
> -bash-3.00# lsmod
> Module                  Size  Used by    Not tainted
> dm_snapshot 17192 1 - Live 0xf8948000
> dm_mod 51736 14 dm_snapshot, Live 0xf8906000
> nfsd 216944 0 - Live 0xf89c4000
> exportfs 5632 1 nfsd, Live 0xf88cf000
>
> The device mapper version itself (as printed in dmesg) is as follows:
>
> device-mapper: ioctl: 4.10.0-ioctl (2006-09-14) initialised:    dm-devel@redhat.com
>
> Since the device mapper is returning an error, the EVMS Snapshot plugin is returning an invalid argument (EINVAL) and exiting.
>
> Any help would be much highly appreciated since we have been facing this issue for a week now...
>
> Thanks in advance for all  your inputs,
>
> srini
