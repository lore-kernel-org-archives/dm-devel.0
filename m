From: "M. Mohan Kumar" <mohan@in.ibm.com>
Subject: Default low water mark threshold for a new thin pool
Date: Tue, 05 Feb 2013 14:30:00 +0530
Message-ID: <87ehgv16gf.fsf@in.ibm.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: dm-devel@redhat.com, lvm-devel@redhat.com
List-Id: dm-devel.ids


Hello,

We are adding a lvm2api for creating a thin pool. During thin pool
creation if user does not specify anything for the low water mark
thresold, it would result in 0 and no events will be generated when thin
pool capacity is reaching its full size. IMHO, if user does not specify
anything during thin pool creation, we can assume some value something
like 25%, so that when a thin pool is consumed more than 75%, there will
be an event generated for that pool.

I am not sure what should be the default low water threshold
percentage. Is there any recommended value for low water threshold value
in dm thin pools?

Regards,
M. Mohan Kumar 

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
