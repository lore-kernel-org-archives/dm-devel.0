From: "Allen Jack" <AJACK@novell.com>
Subject: Opening a dm device reads from cache, not the device.
Date: Wed, 15 Feb 2006 17:05:28 -0700
Message-ID: <43F35F58.8B4D.000D.0@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I have a RAID5 plugin that is also used with clustering.  I open the
raid device (created in device-mapper) using the O_SYNC and O_DIRECT
flags, but it seems to read the data from a cache somewhere.  I put a
printk in my plugin map function, but it doesn't get hit.  If another
node in the cluster changes the data on the disk, it never gets
refreshed on this node because of the caching.

Is there any way to turn off the caching so that all read requests come
to my plugin?  And where is the caching taking place?

Thanks,

Allen

Allen Jack
email - ajack@novell.com
Novell, Inc., the leading provider of information solutions
http://www.novell.com
