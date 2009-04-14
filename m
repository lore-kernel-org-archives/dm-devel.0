From: christophe.varoqui@free.fr
Subject: Re: [RFC] dm snapshot based asynchronous replication
Date: Wed, 15 Apr 2009 01:09:45 +0200 (CEST)
Message-ID: <1293115026.1983411239750585628.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <20090414122812K.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090414122812K.fujita.tomonori@lab.ntt.co.jp>
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

> Zumastor?
>
> http://zumastor.org/

thanks for your prompt response. zumastor is indeed exactly what I need feature-wize. Thanks for pointing it.

Though I'm eager to play with shared exception snapshots, my more pressing need will need to run on unmodified redhat el5. Thus I'm tied to vanilla snapshots, but that could be sufficient for my simplistic replication algorithm if I find a way to list cow'ed chunks : no need for snap-deltas, I'm ok with replicating more data than necessary (that can't be worse a ressource drain than rsync on big vm files).

Should I understand there's no way for userspace to extract from the device mapper the cow'ed chunk list of a vanilla snapshot ?
