From: Dave Pitts <dpitts@cozx.com>
Subject: dm-cache warming
Date: Fri, 26 Jul 2013 09:24:16 -0600
Message-ID: <51F294A0.6080103@cozx.com>
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

Hello:

I've been trying to do some performance testing for a client and can't seem to 
get the dm-cache warmed. The values displayed in the "dmsetup status" command 
seem too low. I've been trying to use the "raw" devices setup for the cache and 
NOT use a file system or database. I've tried sequential writes/reads to the 
devices (ie. dd ) and dividing up the space to be tested and do I/O over a 
number of segments to try to break any sequential I/O tests. Any ideas as to 
what I may doing wrong? Do I need to randomize the I/O?

System: RHEL 7.0 Alpha3, 3.9.7 kernel

Thanks in advance..

-- 
Dave Pitts             PULLMAN: Travel and sleep in safety and comfort.
dpitts@cozx.com
