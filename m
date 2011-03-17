From: Leonid Podolny <leonid.podolny@xtremio.com>
Subject: multipath performance problem
Date: Thu, 17 Mar 2011 15:08:01 +0200
Message-ID: <4D8207B1.1060005@xtremio.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
I'm not sure it's a correct place to write to, but I'm having a weird issue with the multipath which I'm unable to solve on my own.
There is a SAN device that exports each LUN 8 times. I measure performance using btest (http://http://sourceforge.net/projects/btest/). Basically, it writes 4kb chunks of data from multiple threads and gathers statistics -- throughput in IOPs, average latency and such.
When I compare results of writing into /dev/sdXXX's vs. writing into /dev/dm-XXX's, I see that the multipath devices have about 4 times worse throughput (in IOPs), but about 2 times less latency. In addition, the SAN device allows to see how many commands are currently being processed, and when I work via multipath, this number is many times lower.
All the above shows that I am unable to properly saturate the SAN device when working through multipath. I tried disabling the queue in multipathd. What do I miss?

-- 

Cheers, L.
