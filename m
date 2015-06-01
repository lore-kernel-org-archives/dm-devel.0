From: Dennis Yang <shinrairis@gmail.com>
Subject: Re: Poor snapshot performance in linux-3.19
Date: Mon, 1 Jun 2015 18:39:43 +0800
Message-ID: <CAKTMprNub3b2e9w8Y+5QnZW4c-gXf138hq2hS8_78SzyYVJB=w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

> Message: 12
> Date: Fri, 29 May 2015 16:29:37 +0100
> From: Joe Thornber <thornber@redhat.com>
> To: device-mapper development <dm-devel@redhat.com>
> Subject: Re: [dm-devel] Poor snapshot performance in linux-3.19
> Message-ID: <20150529152936.GA4297@rh-vpn>
> Content-Type: text/plain; charset=us-ascii
>
> On Fri, May 29, 2015 at 11:03:28AM +0800, Dennis Yang wrote:
>> The server I have tested is equipped with Xeon E3-1246 with 4 physical
>> cores, so I think CPU might not be the bottleneck of the storage
>> throughput.
>> Any idea?
>
> Is it any better with this patch?
>
> https://github.com/jthornber/linux-2.6/commit/56db3d227ea7e11e42b2b67f8ddc9f6d40c3a3a4
>

Hi,

I just gave it a try this morning, but it looks like the performance
is still the same (drop from 1.8GB/s to 270MB/s after snapshot). I
also make some other experiments. If I make a EXT4 filesystem on top
of a thin device with 64K pool block size, the file I/O throughput
after snapshot is great (drop from 1.2GB/s to 1GB/s only) because of
the bio size is 64KB equals to the pool block size. This makes me
start wondering what throughput level we should expect after
snapshotted. Since we are making 1 write to (1 read + 1 write) + 1
write to complete a write request, maybe the best performance we can
get here is around 25~30% of throughput before snapshot. Please
correct me if I get anything wrong.

Thanks,
Dennis
