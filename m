From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm mpath: integrity errors should not cause failover
Date: Mon, 28 Mar 2011 20:13:28 -0400
Message-ID: <yq14o6mkclz.fsf@sermon.lab.mkp.net>
References: <1301341030-28997-1-git-send-email-snitzer@redhat.com>
	<20110328194831.GA29351@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110328194831.GA29351@redhat.com> (Mike Snitzer's message of
	"Mon, 28 Mar 2011 15:48:32 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Though this change could easily be considered a fix (for those
Mike> lucky enough to even have a DIF/DIX capable mpath
Mike> configuration)...

Yeah, I actually fixed this in my tree as a result of a user bug report.

-- 
Martin K. Petersen	Oracle Linux Engineering
