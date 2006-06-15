From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Next set of device-mapper  patches
Date: Thu, 15 Jun 2006 15:56:39 +0100
Message-ID: <20060615145639.GJ27639@agk.surrey.redhat.com>
References: <20060610160024.36F82733FA@hormel.redhat.com>
	<3EC60E80D9AA7C4E910ACC9DA2003AC305FEAEFA@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3EC60E80D9AA7C4E910ACC9DA2003AC305FEAEFA@BGEEXC02.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 15, 2006 at 08:22:02PM +0530, Singh, Santosh (STSD) wrote:
> below) in  order as given in the "series" file on linux-2.6.16.16. I
> think the patch is not being applied ,since it prompts many times e.g

You need to look at the comments against the patches and decide which
ones to apply.

For example, if you're starting from 2.6.16.16
you cannot apply:
  patch-2.6.17-rc4
  patch-2.6.17-rc4-rc5
  patch-2.6.17-rc5-rc6

Nor the section of kgdb patches (which may need tweaking if you did want
kgdb against a different kernel).

Alasdair
-- 
agk@redhat.com
