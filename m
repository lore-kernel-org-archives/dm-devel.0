From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: dump of ext3 very slow from dm LV
Date: Tue, 10 Jul 2007 12:24:01 -0400
Message-ID: <4693B2A1.4090703@cfl.rr.com>
References: <20070630202821.GA2770@kallisti.us>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070630202821.GA2770@kallisti.us>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ross Vandegrift <ross@kallisti.us>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Ross Vandegrift wrote:
> I'm seeing speeds in the range of 3-4MiB/s.  If I increase dump's
> blocksize to 128KiB records, speed jumps up to about 20KiB/s, which
> is better but still frustratingly slow. Going to 1024KiB gets me
> about 28MiB/s.
> 
> Today I loop mounted a file on my LVM, filled it up with some crap
> from urandom and dumped it out.  I was able to get 50-60MiB/s.  
> 
> Is this amount of performance loss due to dm expected? My LV is just two
> SATA hard disks that I put into a VG. Stupid benchmarks with dd gives me
> a raw read speed from the LV of about 60MiB/sec.
> 
> I'm using kernel 2.6.18-4-686 from debian.  Any ideas on what's
> slowing down dump? 

My first impression is nothing is slowing things down.  This all appears 
normal.  Dumping or taring files in the filesystem isn't going to 
operate near the max sequential throughput of the drive.  Also you 
haven't tested without LVM so you have no basis to assume it is a 
problem with LVM.
