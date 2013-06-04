From: Tomas Vanderka <tomas.vanderka@gmail.com>
Subject: Re: [linux-lvm] Mounted,
 but idle LVM volume causes constant disk writes
Date: Tue, 04 Jun 2013 13:00:26 +0200
Message-ID: <51ADC8CA.4010800@gmail.com>
References: <CAEp_DRC=xOm-yWLGR27PnsuLPTTXcPMnKLSmk+iS1VLDG0hKtw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEp_DRC=xOm-yWLGR27PnsuLPTTXcPMnKLSmk+iS1VLDG0hKtw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-lvm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/04/2013 07:46 AM, Bostjan Skufca wrote:
> Hello,
> 
> If LVM2 volume is mounted (ext4 fs), why is there constant write activity to the devices below (sw raid in this case) despite not using the mounted volume at all?
> 
> I am seing this on multiple hosts. On this particular one I am seeing around 20 writes per second on average, but they occur in batches of around 50-90 writeIOps on every
> 3-4 seconds. If I mount the same filesystem (ext4) on sw raid1 without LVM in between, I see the expected 0 write IOps when not using the filesystem.
> 

Just out of curiosity I looked at my systems and I don't see any such IO, even for mounted FS.

You can try running following commands to log writes and where are they comming from (show the result via dmesg)

echo 1 > /proc/sys/vm/block_dump; sleep 10; echo 0 > /proc/sys/vm/block_dump;

By doing so I noticed dm-thin writing to my otherwise unused dm thin pool every second. After looking at the code in dm-thin.c, it looks like the kernel is periodically
commiting metadata every second even if there was no IO to the pool in the time period. I think process_deferred_bios function should probably check if anything changed
before commiting metadata unconditionally when 1s timer is up. Looks like dm-cache-target.c is doing it right.

t.
