From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-crypt: Properly handle extra
	key	string in initialization
Date: Wed, 30 Oct 2013 02:48:14 +0000
Message-ID: <20131030024814.GA17405@agk-dp.fab.redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382998864-10380-1-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 28, 2013 at 11:21:03PM +0100, Milan Broz wrote:
> +			cc->key_extra_size = cc->key_size / cc->key_parts;

I don't understand the logic that leads to this assignment.

Are there some implicit constraints on the input?

Do all invalid inputs produce an appropriate error?

Is there a clearer way to set out the calculation and can it be annotated?

Can we rename key_extra_size to extrakey_size (like subkey_size)?

Is extrakey_size always less than subkey_size?

Alasdair
