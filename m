From: John Utz <John.Utz@wdc.com>
Subject: creating a dm-linear.ko in a current kernel.
Date: Mon, 24 Feb 2014 22:01:44 +0000
Message-ID: <8A51900D08212F40B3DE22453052F6980B97CF4E@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello;

I have a linear device that i am attempting to harness to device mapper.

My expectation that i developed based on my reading was that I could start from a dm-linear.c => dm-linear.ko and go from there.

But dm-linear.c gets linked into dm-mod.ko, not dm-linear.ko.

Has dm-linear always been part of dm-mod? i see some stuff on the net that implies the existence of dm-linear.ko, but i have poked around in menuconfig and i can find no specific entry to create it.

Any suggestions as to how to proceed would be greatly appreciated.

tnx!

johnu
