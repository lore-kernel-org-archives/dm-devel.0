From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: compiling Multipath-tools on RHE4 .
Date: Wed, 23 Mar 2005 18:53:12 +0000
Message-ID: <20050323185312.GU19749@agk.surrey.redhat.com>
References: <1111522135.29700.8.camel@localhost>
	<1111531414.7024.17.camel@zezette>
	<20050322225024.GQ19749@agk.surrey.redhat.com>
	<1111533723.7024.24.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1111533723.7024.24.camel@zezette>
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

On Wed, Mar 23, 2005 at 12:22:03AM +0100, christophe varoqui wrote:
> What problems does the Makefile patch tries to address ? is it redhat
> specific ?

RPM scripts handle compression of the man pages.

(There might be a way to tell it the pages are already compressed, 
I don't know, I was in a hurry and just needed to make things work.)

Alasdair
-- 
agk@redhat.com
