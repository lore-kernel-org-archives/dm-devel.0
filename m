From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: commit 298a9fa dm crypt: use per-bio data hard crash
 kernel ( the system freezes )
Date: Mon, 18 Aug 2014 16:04:11 +0200
Message-ID: <53F207DB.5090909@redhat.com>
References: <53F0F7C7.2010501@winsoft.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53F0F7C7.2010501@winsoft.pl>
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
Cc: kkolasa@winsoft.pl, mpatocka@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 08/17/2014 08:43 PM, Krzysztof Kolasa wrote:
> On x86 after truecrypt mount device system freezes.
>
> console: truecrypt --mount, last argument (admin,user password) after
> Enter - create oops on console, system freezes
> gnome shell: when mount truecrypt drive - freezes system
>
> On x86_64 all working OK.
>
> revert commit [ 298a9fa dm crypt: use per-bio data ] restores the
> ability to use truecrypt on 3.17-rc1 x86 kernel
>
> Krzysztof
>

Hi Krzysztof,

please could you share more details about your setup? I couldn't 
reproduce the crash you wrote about. I tried with truecrypt 7.1 and 
cryptsetup-1.6.4 with no 'success'. What cipher did you use? I tried 
with aes-xts-plain64...

Kind regards
O.
