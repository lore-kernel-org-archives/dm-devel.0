From: John Utz <John.Utz@wdc.com>
Subject: if i create a new dm target type,
 do i need to add its init to the _inits[] and its exit to the
 _exits[]?
Date: Wed, 7 May 2014 04:45:11 +0000
Message-ID: <8A51900D08212F40B3DE22453052F6981D0F0297@wdscexmb02>
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

While looking thru dm.c trying to figure out how to add new target specific errors and sense codes I came across the following arrays: 

static int (*_inits[])(void) __initdata = {
        local_init,
        dm_target_init,
        dm_linear_init,
        dm_stripe_init,
        dm_io_init,
        dm_kcopyd_init,
        dm_interface_init,
        dm_statistics_init,
};

static void (*_exits[])(void) = {
        local_exit,
        dm_target_exit,
        dm_linear_exit,
        dm_stripe_exit,
        dm_io_exit,
        dm_kcopyd_exit,
        dm_interface_exit,
        dm_statistics_exit,
};


What are the rules for what goes in to these? I don't see every dm-* target listed in these and i am curious as to what are the differences between what goes into these arrays and what does not.

tnx!

johnu
