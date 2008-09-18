From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Barrier support in device mapper
Date: Thu, 18 Sep 2008 11:27:37 +0530
Message-ID: <200809181127.37704.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair

What are plans in supporting barriers in device mapper?

Sometime back Andi Kleen posted a patch[1] to support barriers for single-
device dm-devices.

Recently Milan Broz posted an RFC patch-set[2] to implement full-barrier 
support.

Are we going to get full-barrier support soon? If not, I would like to see 
Andi's patch being merged till we get full barrier support ready. I would like 
to know your thoughts.

Thanks
Nikanth Karthikesan
SUSE Labs

[1] http://lkml.org/lkml/2008/2/15/125
[2] http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/5941
