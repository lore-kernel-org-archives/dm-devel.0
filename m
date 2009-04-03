From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0 of 33] Generalized device-mapper exception
	store API
Date: Fri, 3 Apr 2009 11:54:09 +0900
Message-ID: <20090403115414I.fujita.tomonori@lab.ntt.co.jp>
References: <1238017479.20668.6.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238017479.20668.6.camel@hydrogen.msp.redhat.com>
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

On Wed, 25 Mar 2009 16:44:36 -0500
Jonathan Brassow <jbrassow@redhat.com> wrote:

> I've updated the patches for 2.6.29.  I've pulled in 3 patches that
> weren't applying cleanly from "group 1", added 1 more patch to "group
> 2", and pulled the shared exception store patch (I'll send that
> separately).
> 
> I have adjusted the bundles appropriately:
> http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%
> 20group2/
> 
> The bundle for group1 had been removed.
> 
> Please be aware if you are working off of agk's series file, the first
> three patches in this group supersede what is there.

Thanks a lot!

Is there a git tree including all the patches? I tried to apply
patches but I failed somehow. A git tree makes life much easier.
