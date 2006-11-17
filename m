From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.19-rc6 -- dm: possible recursive locking detected
Date: Fri, 17 Nov 2006 19:43:03 +0000
Message-ID: <20061117194303.GB4409@agk.surrey.redhat.com>
References: <20061117153003.GB7131@osiris.boeblingen.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061117153003.GB7131@osiris.boeblingen.de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 17, 2006 at 04:30:03PM +0100, Heiko Carstens wrote:
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.19-rc6-g1b9bb3c1 #28
> ---------------------------------------------
> kpartx/945 is trying to acquire lock:
>  (&md->io_lock){----}, at: [<00000000001f8faa>] dm_request+0x42/0x24c
> 
> but task is already holding lock:
>  (&md->io_lock){----}, at: [<00000000001f8faa>] dm_request+0x42/0x24c
 
Known problem - nobody's written a patch to fix it yet to my knowledge,
but I don't recall any reports of real world lock-ups related to this - just
several reports of the debug warning messages:-)

Simply ignore the message for now - or submit a patch that fixes the
underlying problem:-)

Alasdair
-- 
agk@redhat.com
