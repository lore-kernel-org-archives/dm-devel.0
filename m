From: "Andrei B." <andrixnet@yahoo.com>
Subject: multipaths and timings
Date: Wed, 6 Mar 2013 13:59:17 -0800 (PST)
Message-ID: <1362607157.4684.YahooMailClassic@web126201.mail.ne1.yahoo.com>
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

I have discovered that loading the dm-multipath and running multipath binary to map the paths, then immediately loading the configuration of LVM, that uses volumes configured via fibre channel does not work. At that stage in the boot process, LVM still does not find the multipathed devices. 

I introduced a delay of several seconds (sleep 5s) after multipath binary, and before LVM, and voila, the devices are correctly detected and initialized by LVM. 

I was just wandering : is this the proper way to do things? Or am I missing something (that causes LVM to be unable to detect devices immediately after multipath is run) ?

Thanks
