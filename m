From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC][PATCH] dm-cow: copy-on-write stackable target
	for device-mapper
Date: Mon, 11 Dec 2006 12:57:03 -0600
Message-ID: <a4e6962a0612111057i48993e19j5048ac26b96f4714@mail.gmail.com>
References: <200611271659.kARGx5qb017564@hera.kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611271659.kARGx5qb017564@hera.kernel.org>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, paurea@gmail.com
List-Id: dm-devel.ids

On 11/27/06, Eric Van Hensbergen <ericvh@hera.kernel.org> wrote:
> Subject: [RFC] [PATCH] dm-cow: copy-on-write stackable target for device-mapper
>
> This is the first cut of a device-mapper target which allows stacking of
> multiple block devices and in which the top-layer of the stack is a
> copy-on-write layer.  It was originally developed in support of a cluster
> image management solution.
>

The paper describing our motivation for this work including some
description of this implementation and performance results is now
available:

http://domino.research.ibm.com/library/cyberdig.nsf/1e4115aea78b6e7c85256b360066f0d4/801d563d3be022198525723c006fafc1?OpenDocument

           -eric
