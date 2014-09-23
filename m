From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Tue, 23 Sep 2014 19:07:35 -0400
Message-ID: <yq18ulaszpk.fsf@sermon.lab.mkp.net>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	(heinzm@redhat.com's message of "Tue, 23 Sep 2014 18:51:46 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

>>>>> "Heinz" == heinzm  <heinzm@redhat.com> writes:

Heinz> In case of RAID levels 4,5 and 6 we have to check for the
Heinz> capability to zero data on discards to avoid stripe data
Heinz> corruption.

I'm quite concerned about relying on discard_zeroes_data since it's a
hint and not a hard guarantee.

-- 
Martin K. Petersen	Oracle Linux Engineering
