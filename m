From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Re: [PATCH] dm: Data integrity support
Date: Sun, 29 Mar 2009 14:42:04 -0400
Message-ID: <49CFC0FC.2070209@redhat.com>
References: <yq1sklm9h1e.fsf@sermon.lab.mkp.net>
	<20090327212030.GV13664@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090327212030.GV13664@agk.fab.redhat.com>
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

Alasdair G Kergon wrote:
> On Mon, Mar 09, 2009 at 11:46:05PM -0400, Martin K. Petersen wrote:
>> This patch requires a change in Jens' for-linus branch that adds a GFP
>> mask to bio_integrity_clone() and obsoletes the bio_set argument.
>  
> I've not had the chance to track down that patch, but if you can note
> in this thread when it's hit Linus's tree, then I'll submit this one
> behind it.

Seems that change has been committed to Linus's tree with commit:
87092698c665e0a358caf9825ae13114343027e8

Mike
