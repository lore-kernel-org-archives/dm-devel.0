From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: tiny bug
Date: Tue, 19 Jul 2005 01:16:45 +0200
Message-ID: <1121728606.19015.42.camel@zezette>
References: <20050718215304.GE24376@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050718215304.GE24376@phlogiston.msp.redhat.com>
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

On lun, 2005-07-18 at 16:53 -0500, Benjamin Marzinski wrote:
> mulitpathd was crashing when I entered an empty line at the CLI prompt, because
> the output buffer from get_word was being checked to see if it was NULL, but
> get_word never explicitly sets the buffer to NULL if there is no word.
> 
> The patch fixes this.
> 
Applied, thanks.
-- 
christophe varoqui <christophe.varoqui@free.fr>
