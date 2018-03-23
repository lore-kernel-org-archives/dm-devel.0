From: Denis Semakin <d.semakin@omprussia.ru>
Subject: Re: [PATCH] dm table: add support for secure erase
 forwarding [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Fri, 23 Mar 2018 18:25:47 +0300 (MSK)
Message-ID: <1686283079.319969.1521818747806.JavaMail.zimbra@omprussia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

>I'd feel safer about having targets opt-in with setting (a new)
>ti->num_secure_erase_bios.
May be add a new field "bool secure_erase_supported:1" in dm_target structure instead?
And set up it "true" in constructor for linear targets.

Denis
