From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Fri, 04 Sep 2009 13:02:28 +0900 (JST)
Message-ID: <20090904.130228.104054439.ryov@valinux.co.jp>
References: <20090901165011.GB3753@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090901165011.GB3753@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Ryo,
> 
> I decided to play a bit more with dm-ioband and started doing some
> testing. I am doing a simple two dd threads doing reads and don't seem
> to be gettting the fairness. So thought will ask you what's the issue
> here. Is there an issue with my testing procedure.

Thank you for testing dm-ioband. dm-ioband is designed to start
throttling bandwidth when multiple IO requests are issued to devices
simultaneously, IOW, to start throttling when IO load exceeds a
certain level.

Here is my test script that runs multiple dd threads on each
directory. Each directory stores 20 files of 2GB.

    #!/bin/sh
    tmout=60

    for nr_threads in 1 4 8 12 16 20; do
            sync; echo 3 > /proc/sys/vm/drop_caches

            for i in $(seq $nr_threads); do
                    dd if=/mnt1/ioband1.${i}.0 of=/dev/null &
                    dd if=/mnt2/ioband2.${i}.0 of=/dev/null &
            done
            iostat -k 1 $tmout > ${nr_threads}.log
            killall -ws TERM dd
    done
    exit 0

Here is the result. The average throughputs of each device are
according to the proportion of the weight settings when the number of
thread is over four.

              Average thoughput in 60 seconds [KB/s]

              ioband1           ioband2
  threads    weight 200        weight 100       total
        1   26642 (54.9%)     21925 (45.1%)     48568
        4   33974 (67.7%)     16181 (32.3%)     50156
        8   31952 (66.2%)     16297 (33.8%)     48249
       12   32062 (67.8%)     15236 (32.2%)     47299
       16   31780 (67.7%)     15165 (32.3%)     46946
       20   29955 (66.3%)     15239 (33.7%)     45195

Please try to run the above script on your envirionment and I would be
glad if you let me know the result.

Thanks,
Ryo Tsuruta
