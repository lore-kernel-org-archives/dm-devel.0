From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC,
	PATCH] dm-log.c: Work with devices with hard-sector-size > 512 bytes
Date: Tue, 28 Mar 2006 15:18:31 +0100
Message-ID: <20060328141831.GC2690@agk.surrey.redhat.com>
References: <200603271546.25508.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200603271546.25508.kevcorry@us.ibm.com>
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

On Mon, Mar 27, 2006 at 03:46:24PM -0600, Kevin Corry wrote:
> However, this necessitated a change of the disk-log version
> from 2 to 3, meaning the new code would not be compatible with any
> existing disk-logs. 

Several points:
  The patch should have no impact on existing users for whom everything
  is working OK - compatibility should be preserved.

  People who need the patch are unable to use this code yet so there's no
  need to preserve compatibility for them.

  We need to continue to support disk logs being loaded onto different
  machines/devices from where they were created.

  If there's no alternative but to take the disruptive step of changing
  the header version number (not convinced of that yet) then we should
  fix other problems with the header at the same time e.g. LOG_OFFSET
  should only be used when creating a new log, not when reading an
  existing one (ie store it in the header); version should include
  compatibility mechanism (flags and/or major/minor) etc.

Alasdair
-- 
agk@redhat.com
