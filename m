From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add name checks in dmsetup
Date: Wed, 7 Jan 2009 01:49:10 +0000
Message-ID: <20090107014910.GF3512@agk.fab.redhat.com>
References: <4963D8E0.4080208@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4963D8E0.4080208@redhat.com>
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

On Tue, Jan 06, 2009 at 11:19:12PM +0100, Peter Rajnoha wrote:
> Checks added for DM device names to allow only names < DM_NAME_LEN, 
> otherwise a part of
> lengthy name would be silently ignored and could cause confusion while 
> using dmsetup.
> Also, the name should not contain '/' character, if it is used in context 
> of creating
> a new device or renaming the existing one (because we do not consider full 
> path to devices,
> they do not exist in filesystem yet) and appropriate error messages are 
> shown.
 
Reviewed-by: Alasdair G Kergon <agk@redhat.com>

Alasdair
-- 
agk@redhat.com
