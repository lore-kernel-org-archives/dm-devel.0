From: Brian Jackson <iggy@theiggy.com>
Subject: Any way to access start/len of i/o from path selector?
Date: Tue, 6 Jul 2010 13:07:52 -0500
Message-ID: <201007061307.52934.iggy@theiggy.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I have a group of storage appliances that implement raid over the network. The 
data is spread out redundantly over the entire group of appliances. I can 
access the entire array from each member. When you access a block that isn't 
physically on that host, that appliance proxies the request to the device that 
does have the block. So every block is accessible on every appliance, but it 
would be best to request the block from the box that actually has it. Since 
the blocks are evenly striped across the appliances, it's pretty easy to 
mathematically figure out which appliance to ask. The only problem I'm having 
is trying to access info about the request (start/len) from the path selector. 
Realistically I just need the start address. I can't see breaking the i/o 
across "array block boundaries" being a huge win.

Is there maybe another way to do this that would work better?
