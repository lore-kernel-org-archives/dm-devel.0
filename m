From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Do not try to activate path if pgpath is NULL
Date: Thu, 6 Nov 2008 10:47:20 +0000
Message-ID: <20081106104720.GA14593@agk.fab.redhat.com>
References: <1225943926.14830.1099.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225943926.14830.1099.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 05, 2008 at 07:58:46PM -0800, Chandra Seetharaman wrote:
> Path activation code is called even when the pgpath is NULL. This could
> lead to a panic in activate_path(). Such a panic is seen in -rt kernel.
 
Added to -mm and will push for .28

Alasdair
-- 
agk@redhat.com
