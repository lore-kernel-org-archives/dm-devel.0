From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Tue, 28 Apr 2009 23:34:56 +0100
Message-ID: <20090428223456.GV23302@agk.fab.redhat.com>
References: <200904281145.40357.knikanth@suse.de>
	<1240947327.13184.13.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1240947327.13184.13.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 28, 2009 at 12:35:27PM -0700, Chandra Seetharaman wrote:
> I am working on a patch on keeping it 2 seconds and adding a parameter
> giving user/user space tool the control to change it to any number.
 
Either that or provide justification inline for why 2 seconds
is always a sensible value to use.

Alasdair
-- 
agk@redhat.com
