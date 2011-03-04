From: Charles Slivkoff <slivkoff@cmu.edu>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Fri, 04 Mar 2011 12:34:07 -0500
Message-ID: <4D71228F.3020700@cmu.edu>
References: <4D6BFCF9.4080809@cmu.edu>	<4D6E91E7.4010305@cmu.edu>	<4D6ECAD2.4040807@cmu.edu>	<4D6FBE59.9040000@cmu.edu>	<D8C50530D6022F40A817A35C40CC06A7065777D7C3@DUBX7MCDUB01.EMEA.DELL.COM>,
	<4D700115.8000500@cmu.edu>
	<E463DF2B2E584B4A82673F53D62C2EF4FF56B44B@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4FF56B44B@cosmail01.lsi.com>
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

The lvols are EXT4, and I see that barrier is enabled by-default. I can 
try disabling, but need to investigate a bit.

Also, I believe I may have isolated the problem a bit. I can only cause 
this behavior when I access these volumes from an NFS client.

I think this might be put it out of scope of the dm code.


-Charles



On 3/3/11 23:34 , Moger, Babu wrote:
> I have looked at your logs.. Here are the messages..
>
> Mar  3 15:38:37 rman-ss-03 kernel: sd 1:0:0:0: Done: SUCCESS
> Mar  3 15:38:37 rman-ss-03 kernel:         2 sd 1:0:0:0:
> Mar  3 15:38:37 rman-ss-03 kernel:         command: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
> Mar  3 15:38:37 rman-ss-03 kernel: : Current: sense key: Illegal Request
> Mar  3 15:38:37 rman-ss-03 kernel:<<vendor>>  ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
> Mar  3 15:38:37 rman-ss-03 kernel:
> Mar  3 15:38:38 rman-ss-03 kernel: sd 1:0:0:0: Done: SUCCESS
> Mar  3 15:38:38 rman-ss-03 kernel:         2 sd 1:0:0:0:
> Mar  3 15:38:38 rman-ss-03 kernel:         command: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
> Mar  3 15:38:38 rman-ss-03 kernel: : Current: sense key: Illegal Request
> Mar  3 15:38:38 rman-ss-03 kernel:<<vendor>>  ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
>
> These messages are coming  because of Synchronize Cache commands.  It
> may be related to type of filesystem you are on. Did you have barrier
> enabled on your filesystem. I see that these commands are going out
> to target on passive paths.. I dont understand that part yet.
> Normally scsi device handlers block commands going out passive
> paths..This should be coming in a differrent path.. I still have to
> figure that out..
>
