From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: LVM2, RHEL 4 update 2: can't remove logical volume
Date: Wed, 26 Oct 2005 22:02:20 +0100
Message-ID: <20051026210220.GB11086@agk.surrey.redhat.com>
References: <013350FE9CC8AC4EB602045723F47222B9A304@xmb-rtp-215.amer.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <013350FE9CC8AC4EB602045723F47222B9A304@xmb-rtp-215.amer.cisco.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 26, 2005 at 04:30:58PM -0400, Phil Lowden (plowden) wrote:
> I'm getting an error when trying to remove an LV
> that has no mounted filesystem or raw volume on it:
 
> # raw -qa
> # mount|grep lvtest1
               ^^^^^^^
> # lvremove /dev/vgtest2/lvstripe1
                  ^^^^^^^^^^^^^^^^^
>   Can't remove open logical volume "lvstripe1"
 
Run
  dmsetup info -c
to check the state.

Alasdair
-- 
agk@redhat.com
