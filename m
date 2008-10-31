From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Issue with dmsetup
Date: Fri, 31 Oct 2008 03:45:59 +0000
Message-ID: <20081031034559.GT31233@agk.fab.redhat.com>
References: <490AF779.7CED.004D.0@superchoice.com.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <490AF779.7CED.004D.0@superchoice.com.au>
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

On Fri, Oct 31, 2008 at 12:18:01PM +1100, Paul Riddle wrote:
> [root@scrac2 ( mailto:[root@scrac2 ) dev]# dmsetup -v remove -f mpath8 
> device-mapper: remove ioctl failed: Device or resource busy 
> Command failed 
 
So something still has that device open: you need to hunt down what it is.
dmsetup info -c
lsof
mount
etc.

Alasdair
-- 
agk@redhat.com
