From: Nix <nix@esperi.org.uk>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack
	overflow: ide-cd related? dm-related?
Date: Mon, 10 Mar 2008 20:09:18 +0000
Message-ID: <87iqzu5ok1.fsf@hades.wkstn.nix>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
	<20080306161459.GB3702@atrey.karlin.mff.cuni.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080306161459.GB3702@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Thu, 6 Mar 2008 17:14:59 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: Peter Osterlund <petero2@telia.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 6 Mar 2008, Jan Kara said:
>   If you are interested, linux-next or -mm tree should contain a patch now
> that fixes the problem...

As soon as I've figured out why dhclient is failing to establish DHCP
connections from 2.6.14.3 (the DHCPOFFERs seem to get ignored, it's
weird and the kernel shouldn't have anything to do with it, but it does)
so I can actually compile something that works and doesn't knock me off
the net every two minutes, I'll try it :)

(yes, I could try -mm directly, but it's been some weeks since I backed
up, thanks to an abruptly chocolate-filled CD-RW drive, so I'm being a
bit cautious.)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
