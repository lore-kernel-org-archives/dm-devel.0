From: Scott Dungan <scott@gps.caltech.edu>
Subject: FS directly on top of dm devices?
Date: Thu, 16 Apr 2009 16:52:06 -0700
Message-ID: <49E7C4A6.3080301@gps.caltech.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

We recently had an engineer from a large storage vendor suggest that we 
make our file systems directly onto the multipathed devices without 
first creating underlying partitions or using LVM.  Having not run with 
this method in production before, we would like to gather as much 
information as possible first. Initial searches for documentation on 
this method has produced few results, short of a Suse/Novell document 
from 2005 under section 4:

http://support.novell.com/techcenter/sdb/en/2005/04/sles_multipathing.html

Does anyone have any experience with this or can point us to more 
documentation. thoughts or recommendations?

Thanks,

-- 

Scott A Dungan
