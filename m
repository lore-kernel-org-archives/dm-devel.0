From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
Subject: hi . I just found out that `kpartx -d
 /full/path/to/myimg.img` does not release the partition mappings as
 expected.
Date: Wed, 4 Jul 2018 14:26:16 +0200
Message-ID: <CAE4vF2eqMJWE4DpFTL7nNPs6Yns5PuO6-LzZAuwKO34pE3MWtw@mail.gmail.com>
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

I had to do it manually with `dmsetup remove loop?p?`

I am using kernel 4.15.0-24-generic on ubuntu 18.04.

I don't know if it's a bug introduce by ubuntu or a bug in kprtx 0.7.4
(may be alredy fixed ?)

I don't know if I need to remort this as a bug ? where ?
