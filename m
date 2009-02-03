From: Mikulas Patocka <mpatocka@redhat.com>
Subject: shared snapshots
Date: Tue, 3 Feb 2009 01:25:30 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902030118280.16888@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

If you are going to put shared storage into your snapshots, look at this: 
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/

--- this is my snapshot store with Fujita/Daniel's store as a loadable 
module.

So if you are going to do shared storage interface, you must accommodate 
both of these implementations into it.

I still don't understand, how do you intend to patch it on the top of 
existing snapshot code. Definitely, I wouldn't say that it will be an easy 
task. Look at the code and have a fun with it.

Mikulas
